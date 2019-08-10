defmodule LoanRanger.AmortizationTableTest do
  use ExUnit.Case

  alias LoanRanger.Loan
  alias LoanRanger.AmortizationTable

  setup do
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

    {:ok, loan} = Loan.create(params)

    {:ok, %{loan: loan}}
  end

  test "generate_payment_dates/1 generate expected list of dates", %{loan: loan} do
    expected_list_dates =
      [
        ~D[2019-01-15],
        ~D[2019-02-15],
        ~D[2019-03-15],
        ~D[2019-04-15],
        ~D[2019-05-15],
        ~D[2019-06-15],
        ~D[2019-07-15],
        ~D[2019-08-15],
        ~D[2019-09-15],
        ~D[2019-10-15],
        ~D[2019-11-15],
        ~D[2019-12-15],
        ~D[2020-01-15],
        ~D[2020-02-15],
        ~D[2020-03-15],
        ~D[2020-04-15],
        ~D[2020-05-15],
        ~D[2020-06-15]
      ]

    assert AmortizationTable.generate_payment_dates(loan) == expected_list_dates
  end
end
