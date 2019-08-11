defmodule LoanRanger.AmortizationTable do
  @moduledoc """
  Logic for Amortization Tables
  """

  alias LoanRanger.Loan

  @doc """
  Generate monthly payment dates for a loan
  """
  @spec generate_payment_dates(Loan.t) :: [Date.t]
  def generate_payment_dates(%Loan{term: term, opening_date: opening_date}) do
    first_payment_date = Timex.shift(opening_date, months: 1)
    payment_dates_list =
      Enum.reduce(2..term, [first_payment_date], fn(_month, acc) ->
        [previous_payment_date | _tail] = acc
        next_payment_date = Timex.shift(previous_payment_date, months: 1)
        [next_payment_date | acc]
      end)

    Enum.reverse(payment_dates_list)
  end
end
