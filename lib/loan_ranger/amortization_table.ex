defmodule LoanRanger.AmortizationTable do
  @moduledoc """
  Logic for amortization table
  """

  alias LoanRanger.Loan
  alias LoanRanger.Amortization

  defstruct [
    :amortizations
  ]

  @type t() :: %__MODULE__{
          amortizations: list()
        }

  @doc """
  Get amortization table
  """
  @spec calculate(Loan.t()) :: t()
  def calculate(%Loan{
        opening_date: opening_date,
        payments: payments,
        loan_amount: loan_amount,
        annual_interest_rate: annual_interest_rate
      })
      when is_list(payments) and length(payments) > 0 do
    amortizations =
      break_down_payments(
        payments,
        opening_date,
        loan_amount,
        annual_interest_rate,
        []
      )

    {:ok,
     %__MODULE__{
       amortizations: amortizations
     }}
  end

  def calculate(%Loan{}) do
    {:ok,
     %__MODULE__{
       amortizations: []
     }}
  end

  @doc """
  Process amortizations by payment dates
  """
  @spec break_down_payments([Payment.t()], Date.t(), Money.t(), Decimal.t(), list) :: [
          Amortization.t()
        ]
  def break_down_payments(
        [payment | tail],
        previous_payment_date,
        previous_balance,
        annual_interest_rate,
        acc
      ) do
    payment_date = Map.get(payment, :date)

    interest_to_apply = _get_interest_to_apply(annual_interest_rate, payment_date, previous_payment_date)

    amortization = _break_down_payment(payment, previous_balance, interest_to_apply)

    break_down_payments(
      tail,
      payment_date,
      Map.get(amortization, :balance),
      annual_interest_rate,
      [amortization | acc]
    )
  end

  def break_down_payments(
        [],
        _previous_payment_date,
        _previous_balance,
        _annual_interest_rate,
        amortizations
      ),
      do: Enum.reverse(amortizations)

  # Break down Payment.t() into an Amortization.t().
  @spec _break_down_payment(Payment.t(), Money.t(), float) :: Amortization.t()
  defp _break_down_payment(
         payment,
         previous_balance,
         interest_to_apply
       ) do
    {:ok, %Amortization{} = amortization} =
      Amortization.break_down_payment(payment, previous_balance, interest_to_apply)

    amortization
  end

  # Gets interest to apply
  @spec _get_interest_to_apply(Decimal.t(), Date.t(), Date.t()) :: float
  defp _get_interest_to_apply(annual_interest_rate, payment_date, previous_payment_date) do
    daily_interest_rate = _calculates_daily_interest_rate(annual_interest_rate)
    days_for_interest = _calculates_days_for_interest(payment_date, previous_payment_date)
    interest_to_apply = _calculates_interest_to_apply(daily_interest_rate, days_for_interest)

    Decimal.to_float(interest_to_apply)
  end

  # Calculate daily interest rate
  @spec _calculates_daily_interest_rate(Decimal.t()) :: Decimal.t()
  defp _calculates_daily_interest_rate(annual_interest_rate) do
    interest_rate = _percentage_to_decimal(annual_interest_rate)
    Decimal.div(interest_rate, Decimal.new("360"))
  end

  # Calculate days to collect interest
  @spec _calculates_days_for_interest(Date.t(), Date.t()) :: integer
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
