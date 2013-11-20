Before do
  step %{a directory named "watchme/"}
  Philbot.run "tmp/aruba/watchme/"
end

After do
  Philbot.stop
end