require './spec/database_helpers'
require 'bcrypt'

class User

  attr_reader :id, :email, :username, :name

  def initialize(id:, email:, username:, name:)
    @id = id
    @email = email
    @username = username
    @name = name
  end

  def self.create(email:, password:, username:, name:)

    encrypted_password = BCrypt::Password.create(password)

    result = DatabaseConnection.query("INSERT INTO users (email, password, username, name) VALUES('#{email}', '#{encrypted_password}','#{username}', '#{name}') RETURNING id, email, username, name;")

    User.new(id: result[0]['id'], email: result[0]['email'], username: result[0]['username'], name: result[0]['name'])

  end

  def self.find(id:)
    return nil unless id

    result = DatabaseConnection.query("SELECT * FROM users WHERE id = #{id}")
    User.new(id: result[0]['id'], email: result[0]['email'], username: result[0]['username'], name: result[0]['name'])
  end
end
