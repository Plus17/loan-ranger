defmodule LoanRanger.Loan do
  @moduledoc """
  Logic for Loans
  """

  @enforce_keys [
    :currency,
    :loan_amount,
    :annual_interest_rate,
    :payment_amount,
    :opening_date,
    :term
  ]
  defstruct [
    :currency,
    :loan_amount,
    :annual_interest_rate,
    :payment_amount,
    :opening_date,
    :term,
    payments: []
  ]

  @default_opts [currency: :USD]

  @typedoc """
  :USD | :MXN, etc.
  """
  @type currency() :: atom()

  @type t() :: %__MODULE__{
          currency: currency(),
          loan_amount: Money.t(),
          annual_interest_rate: Decimal.t(),
          payment_amount: Money.t(),
          opening_date: Date.t(),
          term: integer(),
          payments: list()
        }

  alias LoanRanger.Payment

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
      currency: :USD,
      loan_amount: %Money{amount: 8500000, currency: :USD},
      annual_interest_rate: #Decimal<60.0>,
      payment_amount: %Money{amount: 759500, currency: :USD},
      opening_date: ~D[2018-12-28],
      term: 18
    }
  }
  ```
  """
  @spec create(map, Keyword.t()) :: {:ok, t()}
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
    currency = Keyword.fetch!(opts, :currency)

    loan = %__MODULE__{
      currency: currency,
      loan_amount: Money.new(loan_amount, currency),
      annual_interest_rate: Decimal.new(annual_interest_rate),
      payment_amount: Money.new(payment_amount, currency),
      opening_date: Date.from_iso8601!(opening_date),
      term: term
    }

    {:ok, loan}
  end

  @doc """
  Load payments.
  Adds to loan struct a list of payments.


  ## Example
  ```
  loan = %LoanRanger.Loan{}

  payments = [
      %{amount: 759_500, date: "2019-01-28"},
      %{amount: 759_500, date: "2019-02-28"},
      %{amount: 759_500, date: "2019-03-28"}
    ]

  iex > LoanRanger.Loan.load_payments(loan, payments)
  {:ok,
    %LoanRanger.Loan{
      loan_amount: %Money{amount: 8500000, currency: :USD},
      annual_interest_rate: #Decimal<60.0>,
      payment_amount: %Money{amount: 759500, currency: :USD},
      opening_date: ~D[2018-12-28],
      term: 18,
      payments: [
             %LoanRanger.Payment{amount: %Money{amount: 759_500, currency: :USD}, date: ~D[2019-01-28]},
             %LoanRanger.Payment{amount: %Money{amount: 759_500, currency: :USD}, date: ~D[2019-02-28]},
             %LoanRanger.Payment{amount: %Money{amount: 759_500, currency: :USD}, date: ~D[2019-03-28]}
           ]
    }
  }
  ```
  """
  @spec load_payments(t(), [map]) :: {:ok, t()}
  def load_payments(%__MODULE__{currency: currency} = loan, payments) when is_list(payments) do
    payments = Enum.map(payments, &build_payment(&1, currency))

    loan_with_payments = Map.put(loan, :payments, payments)

    {:ok, loan_with_payments}
  end

  # Build payment strucr
  @spec build_payment(%{amount: integer, date: binary}, currency()) :: Payment.t()
  defp build_payment(%{amount: amount, date: date}, currency) do
    %Payment{
      amount: Money.new(amount, currency),
      date: Date.from_iso8601!(date)
    }
  end
end
