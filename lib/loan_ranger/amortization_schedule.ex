defmodule LoanRanger.AmortizationSchedule do
  @moduledoc """
  Logic for Amortization Schedule
  """

  alias LoanRanger.Loan
  alias LoanRanger.Amortization
  alias LoanRanger.Helpers.LoanHelper

  defstruct [
    :amortizations,
    :payment_amount,
    :total_principal_paid
  ]

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

  @doc """
  Get amortization schedule
  """
  @spec get(Loan.t) :: AmortizationSchedule.t
  def get(%Loan{opening_date: opening_date, payment_amount: payment_amount, loan_amount: loan_amount, annual_interest_rate: annual_interest_rate} = loan) do
    payment_dates = generate_payment_dates(loan)

    proccess_amortizations(payment_dates, opening_date, payment_amount, loan_amount, annual_interest_rate, [])
  end
  
  @doc """
  Process amortizations by payment dates
  """
  @spec proccess_amortizations([Date.t], Date.t, Money.t, Money.t, Decimal.t, list) :: [Amortization.t]
  def proccess_amortizations([payment_date | tail], previous_payment_date, payment_amount, previous_balance, annual_interest_rate, acc) do
    amortization = calculate_amortization(payment_date, previous_payment_date, payment_amount, previous_balance, annual_interest_rate)

    amortizations = [amortization | acc]

    proccess_amortizations(tail, payment_date, payment_amount, amortization.balance, annual_interest_rate, amortizations)
  end

  def proccess_amortizations([], _previous_payment_date, _payment_amount, _previous_balance, _annual_interest_rate, amortizations), do: Enum.reverse(amortizations)
  
  @doc """
  Calculates an amortization
  """
  @spec calculate_amortization(Date.t, Date.t, Money.t, Money.t, Decimal.t) :: Amortization.t
  def calculate_amortization(payment_date, previous_payment_date, payment_amount, previous_balance, annual_interest_rate) do
    daily_interest_rate = _calculates_daily_interest_rate(annual_interest_rate) |> IO.inspect(label: "daily_interest_rate")
    days_for_interest = _calculates_days_for_interest(payment_date, previous_payment_date) |> IO.inspect(label: "days_for_interest")
    interest_to_apply = _calculates_interest_to_apply(daily_interest_rate, days_for_interest) |> IO.inspect(label: "interest_to_apply")

    float_interest_to_apply = Decimal.to_float(interest_to_apply)

    interest_amount = _calculates_interest_amount(float_interest_to_apply, previous_balance) |> IO.inspect(label: "INTEREST AMOUNT")
    principal = Money.subtract(payment_amount, interest_amount) |> IO.inspect(label: "PRINCIPAL")

    %Amortization{
      date: payment_date,
      payment_amount: payment_amount,
      principal: principal,
      interest: interest_amount,
      balance: Money.subtract(previous_balance, principal) |> IO.inspect(label: "BALANCE")
    }
  end
  
  # Calculate interest amount
  @spec _calculates_interest_amount(Decimal.t, Money.t) :: Money.t
  defp _calculates_interest_amount(interest_to_apply, previous_balance) do
    Money.multiply(previous_balance, interest_to_apply)
  end

  # Calculate daily interest rate
  @spec _calculates_daily_interest_rate(Decimal.t) :: Decimal.t
  defp _calculates_daily_interest_rate(annual_interest_rate) do
    interest_rate = _percentage_to_decimal(annual_interest_rate)
    Decimal.div(interest_rate, Decimal.new("360"))
  end

  # Calculate days to collect interest
  @spec _calculates_days_for_interest(Date.t, Date.t) :: integer
  defp _calculates_days_for_interest(payment_date, previous_payment_date) do
    Date.diff(payment_date, previous_payment_date)
  end

  # Chance decimal percentage to decimal
  @spec _percentage_to_decimal(Decimal.t()) :: Decimal.t()
  defp _percentage_to_decimal(annual_interest_rate) do
    Decimal.div(annual_interest_rate, Decimal.new("100"))
  end
  
  # Calculates interest to apply
  @spec _calculates_interest_to_apply(Decimal.t(), integer) :: Decimal.t()
  defp _calculates_interest_to_apply(daily_interest_rate, days_for_interest) do
    daily_interest_rate
    |> Decimal.mult(days_for_interest)
    |> Decimal.round(2)
  end
end
