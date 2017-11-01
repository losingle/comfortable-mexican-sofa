# Same tag as File, only it handles multiple attachments.
# Generally not a bad idea to handle rendering of this in a partial/helper
#
class ComfortableMexicanSofa::Content::Tag::Files < ComfortableMexicanSofa::Content::Tag::File

  def initialize(context, params_string)
    super
  end

  def content
    return "" if fragment.attachments.blank?

    fragment.attachments.collect do |attachment|
      super(attachment)
    end.join(" ")
  end

  def form_field(view, index, &block)
    name    = "page[fragments_attributes][#{index}][files][]"
    input   = view.send(:file_field_tag, name, {id: nil, multiple: true})

    attachments_partial = if fragment.attachments
      view.render(
        partial: "comfy/admin/cms/pages/fragment_attachments",
        locals: {
          index:        index,
          attachments:  fragment.attachments
        }
      )
    end

    yield [input, attachments_partial].join.html_safe
  end
end

ComfortableMexicanSofa::Content::Renderer.register_tag(
  :files, ComfortableMexicanSofa::Content::Tag::Files
)