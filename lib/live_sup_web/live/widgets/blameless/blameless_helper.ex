defmodule LiveSupWeb.Widgets.Blameless.BlamelessHelper do
  def severity_border_color(severity) do
    severity = String.downcase(severity)

    cond do
      String.contains?(severity, ["sev0"]) -> "!border-l-red-400"
      String.contains?(severity, ["sev1"]) -> "!border-l-orange-400"
      String.contains?(severity, ["sev2"]) -> "!border-l-yellow-400"
      String.contains?(severity, ["sev3"]) -> "!border-l-blue-400"
      true -> "!border-l-secondary"
    end
  end

  def severity_bg_color(severity) do
    severity = String.downcase(severity)

    cond do
      String.contains?(severity, ["sev0"]) -> "!bg-red-400/15"
      String.contains?(severity, ["sev1"]) -> "!bg-orange-400/15"
      String.contains?(severity, ["sev2"]) -> "!bg-yellow-400/15"
      String.contains?(severity, ["sev3"]) -> "!bg-blue-400/15"
      true -> "!bg-secondary/15"
    end
  end

  def severity_bg_ping_color(severity) do
    severity = String.downcase(severity)

    cond do
      String.contains?(severity, ["sev0"]) -> "!bg-red-400/70"
      String.contains?(severity, ["sev1"]) -> "!bg-orange-400/70"
      String.contains?(severity, ["sev2"]) -> "!bg-yellow-400/70"
      String.contains?(severity, ["sev3"]) -> "!bg-blue-400/70"
      true -> "!bg-secondary/70"
    end
  end

  def severity_color(severity) do
    severity = String.downcase(severity)

    cond do
      String.contains?(severity, ["sev0"]) -> "!text-red-400"
      String.contains?(severity, ["sev1"]) -> "!text-orange-400"
      String.contains?(severity, ["sev2"]) -> "!text-yellow-400"
      String.contains?(severity, ["sev3"]) -> "!text-blue-400"
      true -> "!text-secondary"
    end
  end
end
