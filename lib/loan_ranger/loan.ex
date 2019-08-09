defmodule LoanRanger.Loan do
  @moduledoc """
  Logic for Loans
  """

  @enforce_keys [
    :loan_amount,
    :annual_interest_rate,
    :payment_type,
    :payment_amount,
    :opening_date,
    :term,
    :first_payment_date,
    :payday
  ]
  defstruct [
    :loan_amount,
    :annual_interest_rate,
    :payment_type,
    :payment_amount,
    :opening_date,
    :term,
    :first_payment_date,
    :payday
  ]

  @doc """
  Create loan struct

  ## Example
  ```
  params = %{
    loan_amount: "85000",
    annual_interest_rate: "60.0",
    payment_type: :monthly,
    payment_amount: "7595",
    opening_date: "2018-12-28",
    term: 18,
    first_payment_date: "2019-01-15",
    payday: 15
   }

  iex > LoanRanger.Loan.create(params)
  {:ok,
    %LoanRanger.Loan{
      loan_amount: %Money{amount: 8500000, currency: :USD},
      annual_interest_rate: #Decimal<60.0>,
      payment_type: :monthly,
      payment_amount: %Money{amount: 759500, currency: :USD},
      opening_date: ~D[2018-12-28],
      term: 18,
      first_payment_date: ~D[2019-01-15],
      payday: 15
    }
  }

    
  ```
  """
  @spec create(map) :: Loant.t()
  def create(
        %{
          loan_amount: loan_amount,
          annual_interest_rate: annual_interest_rate,
          payment_type: payment_type,
          payment_amount: payment_amount,
          opening_date: opening_date,
          term: term,
          first_payment_date: first_payment_date,
          payday: payday
        }
      )
      when is_binary(loan_amount) and is_binary(annual_interest_rate) and is_atom(payment_type) and
      is_binary(payment_amount) and is_binary(opening_date) and is_integer(term) and is_binary(first_payment_date) and
      is_integer(payday) do

    loan = %__MODULE__{
      loan_amount: Money.parse!(loan_amount),
      annual_interest_rate: Decimal.new(annual_interest_rate),
      payment_type: payment_type,
      payment_amount: Money.parse!(payment_amount),
      opening_date: Date.from_iso8601!(opening_date),
      term: term,
      first_payment_date: Date.from_iso8601!(first_payment_date),
      payday: payday
    }

    {:ok, loan}
  end

end
