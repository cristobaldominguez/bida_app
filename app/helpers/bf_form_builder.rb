class BFFormBuilder < ActionView::Helpers::FormBuilder
  def bf_value_field(method, value, options = {})
    options['class'] = 'field__value-input'

    @template.content_tag(:div, class: 'field__value') do
      @template.text_field(@object_name, method, objectify_options(options)) +
        @template.content_tag(:span, value.html_safe, class: 'field__value-span')
    end
  end

  def bf_number_field(method, value, options = {})
    options['class'] = 'field__value-input'

    @template.content_tag(:div, class: 'field__value') do
      @template.number_field(@object_name, method, objectify_options(options)) +
        @template.content_tag(:span, value.html_safe, class: 'field__value-span')
    end
  end
end
