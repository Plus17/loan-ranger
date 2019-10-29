defmodule LoanRanger.AmortizationScheduleTest do
  use ExUnit.Case

  import Money.Sigils

  alias LoanRanger.Loan
  alias LoanRanger.Amortization
  alias LoanRanger.AmortizationSchedule

  setup do
    params = %{
      loan_amount: 8_500_000,
      annual_interest_rate: "60.0",
      payment_amount: 727_143,
      opening_date: "2018-12-28",
      term: 18
    }

    {:ok, loan} = Loan.create(params)

    {:ok, %{loan: loan}}
  end

  test "generate_payment_dates/1 returns expected list of dates", %{loan: loan} do
    expected_list_dates = [
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

    generated_list_dates = AmortizationSchedule.generate_payment_dates(loan)

    assert generated_list_dates == expected_list_dates
    assert Enum.count(generated_list_dates) == loan.term
  end

  test "get/1 returns the right amortization schedule", %{loan: loan} do
    expected_amortizations = [
      %Amortization{
        date: ~D[2019-01-28],
        payment_amount: ~M[727_143],
        principal: ~M[302_143],
        interest: ~M[425_000],
        balance: ~M[8_197_857]
      },
      %Amortization{
        date: ~D[2019-02-28],
        payment_amount: ~M[727_143],
        principal: ~M[317_250],
        interest: ~M[409_893],
        balance: ~M[7_880_607]
      },
      %Amortization{
        date: ~D[2019-03-28],
        payment_amount: ~M[727_143],
        principal: ~M[333_113],
        interest: ~M[394_030],
        balance: ~M[7_547_494]
      },
      %Amortization{
        date: ~D[2019-04-28],
        payment_amount: ~M[727_143],
        principal: ~M[349_768],
        interest: ~M[377_375],
        balance: ~M[7_197_726]
      },
      %Amortization{
        date: ~D[2019-05-28],
        payment_amount: ~M[727_143],
        principal: ~M[367_257],
        interest: ~M[359_886],
        balance: ~M[6_830_469]
      },
      %Amortization{
        date: ~D[2019-06-28],
        payment_amount: ~M[727_143],
        principal: ~M[385_620],
        interest: ~M[341_523],
        balance: ~M[6_444_849]
      },
      %Amortization{
        date: ~D[2019-07-28],
        payment_amount: ~M[727_143],
        principal: ~M[404_901],
        interest: ~M[322_242],
        balance: ~M[6_039_948]
      },
      %Amortization{
        date: ~D[2019-08-28],
        payment_amount: ~M[727_143],
        principal: ~M[425_146],
        interest: ~M[301_997],
        balance: ~M[5_614_802]
      },
      %Amortization{
        date: ~D[2019-09-28],
        payment_amount: ~M[727_143],
        principal: ~M[446_403],
        interest: ~M[280_740],
        balance: ~M[5_168_399]
      },
      %Amortization{
        date: ~D[2019-10-28],
        payment_amount: ~M[727_143],
        principal: ~M[468_723],
        interest: ~M[258_420],
        balance: ~M[4_699_676]
      },
      %Amortization{
        date: ~D[2019-11-28],
        payment_amount: ~M[727_143],
        principal: ~M[492_159],
        interest: ~M[234_984],
        balance: ~M[4_207_517]
      },
      %Amortization{
        date: ~D[2019-12-28],
        payment_amount: ~M[727_143],
        principal: ~M[516_767],
        interest: ~M[210_376],
        balance: ~M[3_690_750]
      },
      %Amortization{
        date: ~D[2020-01-28],
        payment_amount: ~M[727_143],
        principal: ~M[542_605],
        interest: ~M[184_538],
        balance: ~M[3_148_145]
      },
      %Amortization{
        date: ~D[2020-02-28],
        payment_amount: ~M[727_143],
        principal: ~M[569_736],
        interest: ~M[157_407],
        balance: ~M[2_578_409]
      },
      %Amortization{
        date: ~D[2020-03-28],
        payment_amount: ~M[727_143],
        principal: ~M[598_223],
        interest: ~M[128_920],
        balance: ~M[1_980_186]
      },
      %Amortization{
        date: ~D[2020-04-28],
        payment_amount: ~M[727_143],
        principal: ~M[628_134],
        interest: ~M[99_009],
        balance: ~M[1_352_052]
      },
      %Amortization{
        date: ~D[2020-05-28],
        payment_amount: ~M[727_143],
        principal: ~M[659_540],
        interest: ~M[67_603],
        balance: ~M[692_512]
      },
      %Amortization{
        date: ~D[2020-06-28],
        payment_amount: ~M[727_143],
        principal: ~M[692_517],
        interest: ~M[34_626],
        balance: ~M[-5]
      }
    ]

    {:ok, amortization_schedule} = AmortizationSchedule.get(loan)

    amortizations = Map.get(amortization_schedule, :amortizations)

    assert Enum.count(amortizations) == loan.term
    assert amortizations == expected_amortizations
  end
end
