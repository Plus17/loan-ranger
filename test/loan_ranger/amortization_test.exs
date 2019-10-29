defmodule LoanRanger.AmortizationTest do
  @moduledoc false

  use ExUnit.Case

  import Money.Sigils

  alias LoanRanger.Amortization
  alias LoanRanger.Payment

  test "break_down_payment/3 return amortization" do
    payment = %Payment{
      date: ~D[2019-01-28],
      amount: Money.new(727_143)
    }

    {:ok, amortization} =
      Amortization.break_down_payment(payment, ~M[8_500_000]USD, 0.05)

    assert amortization == %Amortization{
             date: ~D[2019-01-28],
             payment_amount: ~M[727_143],
             principal: ~M[302_143],
             interest: ~M[425_000],
             balance: ~M[8_197_857]
           }
  end
end
