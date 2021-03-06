class BitcoinExchange < Sinatra::Base

  get "/withdrawals" do
    login_required
    # list withdrawals (btc, eur)
    haml :"withdrawals/index"
  end


  # WITHDRAWAL_BTC_AMOUNT_MAX = 0.01

  post "/withdrawals" do
    active_user_required

    @withdrawal = { user_id: current_user.id, amount: params[:amount].to_d }

    if params[:type] == "btc"
      withdrawal_btc
    else
      withdrawal_eur
    end

    redirect "/withdrawals"
  end

  private

  def withdrawal_eur
    WithdrawalFiat.create @withdrawal
  end

  def withdrawal_btc
    withdrawal = WithdrawalBtc.new @withdrawal
    begin
      withdrawal.execute
    rescue WithdrawalError => e
      e.message
    else
      "debug:<br><h1>BTC sent!</h1><br><br>
    transaction: <a href='https://blockchain.info/tx/#{transaction}'>#{transaction}<a>  <br><br><a href=''>go back to home page</a>"
    end
  end

end
