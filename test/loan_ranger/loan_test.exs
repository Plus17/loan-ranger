defmodule LoanTest do
  @moduledoc false

  use ExUnit.Case

  import Money.Sigils

  alias LoanRanger.Loan
  alias LoanRanger.Payment

  test "create/1 return a loan structure" do
    params = %{
      loan_amount: 8_500_000,
      annual_interest_rate: "60.0",
      payment_amount: 759_500,
      opening_date: "2018-12-28",
      term: 18
    }

    assert Loan.create(params) ==
             {:ok,
              %Loan{
                currency: :USD,
                loan_amount: ~M[8_500_000]USD,
                annual_interest_rate: Decimal.new("60.0"),
                payment_amount: ~M[759_500]USD,
                opening_date: Date.from_iso8601!("2018-12-28"),
                term: 18,
                payments: []
              }}
  end

  describe "load_payments/2" do
    test "when payments are valid" do
      params = %{
        loan_amount: 8_500_000,
        annual_interest_rate: "60.0",
        payment_amount: 759_500,
        opening_date: "2018-12-28",
        term: 18
      }

      payments = [
        %{amount: 759_500, date: "2019-01-28"},
        %{amount: 759_500, date: "2019-02-28"},
        %{amount: 759_500, date: "2019-03-28"}
      ]

      {:ok, loan} = Loan.create(params)

      {:ok, loan} = Loan.load_payments(loan, payments)

      assert loan.payments == [
               %Payment{amount: ~M[759_500]USD, date: ~D[2019-01-28]},
               %Payment{amount: ~M[759_500]USD, date: ~D[2019-02-28]},
               %Payment{amount: ~M[759_500]USD, date: ~D[2019-03-28]}
             ]
    end
  end
end
