require 'csv'
class DataImporter
  def self.import_users(csv_file)
    users_data = []
    CSV.foreach(csv_file, headers: true) do |row|
      # 提取所需字段，其他字段用“...existing code...”标识
      users_data << row.to_hash.slice('name', 'email')
    end
    User.insert_all(users_data) if users_data.any?
  end
end
