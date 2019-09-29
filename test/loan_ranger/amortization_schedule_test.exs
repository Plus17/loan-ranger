defmodule LoanRanger.AmortizationScheduleTest do
  use ExUnit.Case

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
      
    generated_list_dates = AmortizationSchedule.generate_payment_dates(loan)

    assert generated_list_dates == expected_list_dates
    assert Enum.count(generated_list_dates) == loan.term
  end

  test "get/1 returns the right amortization schedule", %{loan: loan} do
    expected_table = [
      %Amortization{date: ~D[2019-01-28], payment_amount: Money.new(727_143), principal: Money.new(302_143), interest: Money.new(4250_00), balance: Money.new(8_197_857)},
      %Amortization{date: ~D[2019-02-28], payment_amount: Money.new(727_143), principal: Money.new(317_250), interest: Money.new(4098_93), balance: Money.new(7_880_607)},
      %Amortization{date: ~D[2019-03-28], payment_amount: Money.new(727_143), principal: Money.new(333_113), interest: Money.new(3940_30), balance: Money.new(7_547_494)},
      %Amortization{date: ~D[2019-04-28], payment_amount: Money.new(727_143), principal: Money.new(349_768), interest: Money.new(3773_75), balance: Money.new(7_197_726)},
      %Amortization{date: ~D[2019-05-28], payment_amount: Money.new(727_143), principal: Money.new(367_257), interest: Money.new(3598_86), balance: Money.new(6_830_469)},
      %Amortization{date: ~D[2019-06-28], payment_amount: Money.new(727_143), principal: Money.new(385_620), interest: Money.new(3415_23), balance: Money.new(6_444_849)},
      %Amortization{date: ~D[2019-07-28], payment_amount: Money.new(727_143), principal: Money.new(404_901), interest: Money.new(3222_42), balance: Money.new(6_039_948)},
      %Amortization{date: ~D[2019-08-28], payment_amount: Money.new(727_143), principal: Money.new(425_146), interest: Money.new(3019_97), balance: Money.new(5_614_802)},
      %Amortization{date: ~D[2019-09-28], payment_amount: Money.new(727_143), principal: Money.new(446_403), interest: Money.new(2807_40), balance: Money.new(5_168_399)},
      %Amortization{date: ~D[2019-10-28], payment_amount: Money.new(727_143), principal: Money.new(468_723), interest: Money.new(2584_20), balance: Money.new(4_699_676)},
      %Amortization{date: ~D[2019-11-28], payment_amount: Money.new(727_143), principal: Money.new(492_159), interest: Money.new(2349_84), balance: Money.new(4_207_517)},
      %Amortization{date: ~D[2019-12-28], payment_amount: Money.new(727_143), principal: Money.new(516_767), interest: Money.new(2103_76), balance: Money.new(3_690_750)},
      %Amortization{date: ~D[2020-01-28], payment_amount: Money.new(727_143), principal: Money.new(542_605), interest: Money.new(1845_38), balance: Money.new(3_148_145)},
      %Amortization{date: ~D[2020-02-28], payment_amount: Money.new(727_143), principal: Money.new(569_736), interest: Money.new(1574_07), balance: Money.new(2_578_409)},
      %Amortization{date: ~D[2020-03-28], payment_amount: Money.new(727_143), principal: Money.new(598_223), interest: Money.new(1289_20), balance: Money.new(1_980_186)},
      %Amortization{date: ~D[2020-04-28], payment_amount: Money.new(727_143), principal: Money.new(628_134), interest: Money.new(99_009), balance: Money.new(1_352_052)},
      %Amortization{date: ~D[2020-05-28], payment_amount: Money.new(727_143), principal: Money.new(659_540), interest: Money.new(67_603), balance: Money.new(692_512)},
      %Amortization{date: ~D[2020-06-28], payment_amount: Money.new(727_143), principal: Money.new(692_517), interest: Money.new(34_626), balance: Money.new(-5)}
    ]

    amortization_schedule = AmortizationSchedule.get(loan)

    assert Enum.count(amortization_schedule) == loan.term
    assert amortization_schedule == expected_table
  end
end
