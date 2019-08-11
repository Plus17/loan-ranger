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
      term: 18
    }

    {:ok, loan} = Loan.create(params)

    {:ok, %{loan: loan}}
  end

  test "generate_payment_dates/1 returns expected list of dates", %{loan: loan} do
    expected_list_dates =
      [
        ~D[2019-01-28],
        ~D[2019-02-28],
        ~D[2019-03-28],
        ~D[2019-04-28],
        ~D[2019-05-28],
        ~D[2019-06-28],
        ~D[2019-07-28],
        ~D[2019-08-28],
        ~D[2019-09-28],
        ~D[2019-10-28],
        ~D[2019-11-28],
        ~D[2019-12-28],
        ~D[2020-01-28],
        ~D[2020-02-28],
        ~D[2020-03-28],
        ~D[2020-04-28],
        ~D[2020-05-28],
        ~D[2020-06-28]
      ]
      
    generated_list_dates = AmortizationTable.generate_payment_dates(loan)

    assert generated_list_dates == expected_list_dates
    assert Enum.count(generated_list_dates) == loan.term
  end
end
