module ApplicationHelper

  def title page_title
    content_for(:title) { page_title }
  end

  def flash_messages flash
    flash.each do |name, msg|
      content_for(:flash_messages) do
        content_tag :div, msg, :class => 'alert alert-danger' if msg.is_a?(String) && name==='alert'
        content_tag :div, msg, :class => 'alert alert-success' if msg.is_a?(String) && name==='success'
      end
    end
  end
end
