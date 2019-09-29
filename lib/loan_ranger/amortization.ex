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

end
