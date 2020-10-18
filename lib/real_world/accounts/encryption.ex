defmodule RealWorld.Accounts.Encryption do

  def password_hashing(password), do: Bcrypt.hash_pwd_salt(password)
  def validate_password(password, hash), do: Bcrypt.verify_pass(password, hash)
end
