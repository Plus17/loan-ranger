defmodule LoanTest do
  @moduledoc false

  use ExUnit.Case

  alias LoanRanger.Loan

  test "create/1 return a loan structure" do
    params = %{
      loan_amount: "85000",
      annual_interest_rate: "60.0",
      payment_type: :monthly,
      payment_amount: "7595",
      opening_date: "2018-12-28",
      term: 18,
      first_payment_date: "2019-01-15"
    }
    assert Loan.create(params) == {:ok, %Loan{
       loan_amount: %Money{amount: 8500000, currency: :USD},
       annual_interest_rate: Decimal.new("60.0"),
       payment_type: :monthly,
       payment_amount: %Money{amount: 759500, currency: :USD},
       opening_date: Date.from_iso8601!("2018-12-28"),
       term: 18,
       first_payment_date: Date.from_iso8601!("2019-01-15")
     }
   }
  end

end
