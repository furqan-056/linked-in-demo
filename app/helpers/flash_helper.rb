module FlashHelper
  def flash_color_class(type)
    case type.to_sym
    when :notice, :success
      "bg-green-500"
    when :alert, :error
      "bg-red-500"
    when :warning, :warn
      "bg-yellow-500"
    else
      "bg-gray-500"
    end
  end
end
