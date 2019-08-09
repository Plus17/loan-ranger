defmodule LoanRanger.Loan do
  @moduledoc """
  Logic for Loan
  """

  @enforce_keys [
    :loan_amount,
    :annual_interest_rate,
    :payment_type,
    :payment_amount,
    :opening_date,
    :term,
    :first_payment_date
  ]
  defstruct [
    :loan_amount,
    :annual_interest_rate,
    :payment_type,
    :payment_amount,
    :opening_date,
    :term,
    :first_payment_date
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
    opening_date: ~D[2018-12-28],
    term: 18,
    first_payment_date: ~D[2019-01-15]
   }

  iex > LoanRanger.Loan.create(params)
  {:ok,
    %LoanRanger.Loan{
      annual_interest_rate: "60.0",
      first_payment_date: ~D[2019-01-15],
      loan_amount: "85000",
      opening_date: ~D[2018-12-28],
      payment_amount: "7595",
      payment_type: :monthly,
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
          payment_type: payment_type,
          payment_amount: payment_amount,
          opening_date: %Date{} = opening_date,
          term: term,
          first_payment_date: %Date{} = first_payment_date
        }
      )
      when is_binary(loan_amount) and is_binary(annual_interest_rate) and is_atom(payment_type) and
             is_binary(payment_amount) and is_integer(term) do

    loan = %__MODULE__{
      loan_amount: Money.parse!(loan_amount),
      annual_interest_rate: Decimal.new(annual_interest_rate),
      payment_type: payment_type,
      payment_amount: Money.parse!(payment_amount),
      opening_date: opening_date,
      term: term,
      first_payment_date: first_payment_date
    }

    {:ok, loan}
  end

end
