defmodule LoanRanger.AmortizationTest do
  @moduledoc false

  use ExUnit.Case

  alias LoanRanger.Amortization
  alias LoanRanger.Payment

  test "break_down_payment/3 return amortization" do
    payment = %Payment{
      date: ~D[2019-01-28],
      amount: Money.new(727_143)
    }

    {:ok, amortization} =
      Amortization.break_down_payment(payment, %Money{amount: 8_500_000, currency: :USD}, 0.05)

    assert amortization == %Amortization{
             date: ~D[2019-01-28],
             payment_amount: Money.new(727_143),
             principal: Money.new(302_143),
             interest: Money.new(425_000),
             balance: Money.new(8_197_857)
           }
  end
end
