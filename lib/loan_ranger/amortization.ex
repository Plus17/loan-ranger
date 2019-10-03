defmodule LoanRanger.Amortization do
  @moduledoc """
  Module for amortizations
  """

  defstruct [
    :date,
    :payment_amount,
    :interest,
    :principal,
    :balance
  ]

  @type t() :: %__MODULE__{
          date: Date.t(),
          payment_amount: Money.t(),
          interest: Money.t(),
          principal: Money.t(),
          balance: Money.t()
        }

  @doc """
  Calculates an amortization from payment
  """
  @spec break_down_payment(Payment.t(), Money.t(), float) :: Amortization.t()
  def break_down_payment(
        payment,
        previous_balance,
        interest_to_apply
      ) do
    interest_amount = _calculates_interest_amount(interest_to_apply, previous_balance)
    principal = Money.subtract(payment.amount, interest_amount)

    {:ok,
     %__MODULE__{
       date: payment.date,
       payment_amount: payment.amount,
       principal: principal,
       interest: interest_amount,
       balance: Money.subtract(previous_balance, principal)
     }}
  end

  # Calculate interest amount
  @spec _calculates_interest_amount(float, Money.t()) :: Money.t()
  defp _calculates_interest_amount(interest_to_apply, previous_balance) do
    Money.multiply(previous_balance, interest_to_apply)
  end
end
