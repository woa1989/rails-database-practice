class EmailDomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # ...existing code...
    unless value =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      record.errors.add(attribute, (options[:message] || "不是有效的邮箱格式"))
    end
  end
end
