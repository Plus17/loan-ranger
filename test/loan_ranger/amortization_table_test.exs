defmodule LoanRanger.AmortizationTableTest do
  use ExUnit.Case

  import Money.Sigils

  alias LoanRanger.Loan
  alias LoanRanger.Amortization
  alias LoanRanger.AmortizationTable

  setup do
    params = %{
      loan_amount: 8_500_000,
      annual_interest_rate: "60.0",
      payment_amount: 727_143,
      opening_date: "2018-12-28",
      term: 18
    }

    {:ok, loan} = Loan.create(params)

    payments = [
      %{amount: 727_143, date: "2019-01-28"},
      %{amount: 727_143, date: "2019-02-28"},
      %{amount: 727_143, date: "2019-03-28"}
    ]

    {:ok, loan} = Loan.load_payments(loan, payments)

    {:ok, %{loan: loan}}
  end

  test "get/1 returns the right amortization table", %{loan: loan} do
    expected_amortizations = [
      %Amortization{
        date: ~D[2019-01-28],
        payment_amount:  ~M[727_143],
        principal:  ~M[302_143],
        interest:  ~M[425_000],
        balance:  ~M[8_197_857]
      },
      %Amortization{
        date: ~D[2019-02-28],
        payment_amount:  ~M[727_143],
        principal:  ~M[317_250],
        interest:  ~M[409_893],
        balance:  ~M[7_880_607]
      },
      %Amortization{
        date: ~D[2019-03-28],
        payment_amount:  ~M[727_143],
        principal:  ~M[333_113],
        interest:  ~M[394_030],
        balance:  ~M[7_547_494]
      }
    ]

    {:ok, amortization_table} = AmortizationTable.calculate(loan)

    amortizations = Map.get(amortization_table, :amortizations)

    assert Enum.count(amortizations) == 3
    assert amortizations == expected_amortizations
  end

  test "calculate/1 returns the right amortization table when loan hasn't payments" do
    params = %{
      loan_amount: 8_500_000,
      annual_interest_rate: "60.0",
      payment_amount: 727_143,
      opening_date: "2018-12-28",
      term: 18
    }

    {:ok, loan} = Loan.create(params)

    {:ok, amortization_table} = AmortizationTable.calculate(loan)

    amortizations = Map.get(amortization_table, :amortizations)

    assert Enum.empty?(amortizations)
  end
end
