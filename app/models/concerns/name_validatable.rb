module NameValidatable
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true
    validates :name, length: { minimum: 2, maximum: 50 }
    validates :name, format: { with: /\A[\w\s-]+\z/, message: "只能包含字母、数字、空格和连字符" }
  end

  def normalize_name
    self.name = name.strip.gsub(/\s+/, ' ') if name.present?
  end
end
