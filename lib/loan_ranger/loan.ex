defmodule LoanRanger.Loan do
  @moduledoc """
  Logic for Loans
  """

  @enforce_keys [
    :loan_amount,
    :annual_interest_rate,
    :payment_amount,
    :opening_date,
    :term
  ]
  defstruct [
    :loan_amount,
    :annual_interest_rate,
    :payment_amount,
    :opening_date,
    :term
  ]

  @default_opts [currency: :USD]

  @doc """
  Create loan struct.


  You need to pass monetary values ​​as a positive integer that represents how much in the smallest currency
  unit (for example, 100 cents to $ 1.00).
  You can specify the currency with the argument opts. LoanRanger works with [Money library](https://github.com/elixirmoney/money).
  The default currency is USD.

  ## Example
  ```
  params = %{
    loan_amount: 8_500_000,
    annual_interest_rate: "60.0",
    payment_amount: 759_500,
    opening_date: "2018-12-28",
    term: 18,
   }

  opts = [currency: :USD]

  iex > LoanRanger.Loan.create(params, opts)
  {:ok,
    %LoanRanger.Loan{
      loan_amount: %Money{amount: 8500000, currency: :USD},
      annual_interest_rate: #Decimal<60.0>,
      payment_amount: %Money{amount: 759500, currency: :USD},
      opening_date: ~D[2018-12-28],
      term: 18
    }
  }


  ```
  """
  @spec create(map) :: Loant.t()
  def create(
        %{
          loan_amount: loan_amount,
          annual_interest_rate: annual_interest_rate,
          payment_amount: payment_amount,
          opening_date: opening_date,
          term: term
        },
        opts \\ @default_opts
      )
      when is_integer(loan_amount) and
             is_binary(annual_interest_rate) and
             is_integer(payment_amount) and
             is_binary(opening_date) and
             is_integer(term) do
    currency = Keyword.get(opts, :currency)

    loan = %__MODULE__{
      loan_amount: Money.new(loan_amount, currency),
      annual_interest_rate: Decimal.new(annual_interest_rate),
      payment_amount: Money.new(payment_amount, currency),
      opening_date: Date.from_iso8601!(opening_date),
      term: term
    }

    {:ok, loan}
  end
end
