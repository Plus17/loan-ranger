defmodule LoanRanger.Amortization do
  @moduledoc """
  Module for amortizations
  """

  defstruct [
    :date,
    :payment_amount,
    :interest,
    :principal,
    :balance
  ]

  @type t() :: %__MODULE__{
          date: Date.t(),
          payment_amount: Money.t(),
          interest: Money.t(),
          principal: Money.t(),
          balance: Money.t()
        }
end
