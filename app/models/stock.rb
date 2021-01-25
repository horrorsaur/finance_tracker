class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def self.new_lookup(ticker_symbol) # Directly call this method from the class using self
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
      secret_token: Rails.application.credentials.iex_client[:sandbox_secret_api_key],
      endpoint: 'https://sandbox.iexapis.com/v1',
    )
    
    begin # Ruby version of try catch block
      new(ticker: ticker_symbol , name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol)) 
    rescue => exception
      return nil
    end
  end

  def self.check_db(ticker_symbol) # No need to call Stock class because it is implied
    where(ticker: ticker_symbol).first
  end

end
