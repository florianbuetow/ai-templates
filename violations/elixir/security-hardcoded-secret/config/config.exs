import Config

config :test_otp_app,
  secret_key_base: "super_secret_value_that_should_not_be_hardcoded_here_1234567890abcdef"

if Mix.env() == :dev do
  config :git_hooks,
    auto_install: true,
    verbose: true,
    hooks: [
      pre_commit: [
        tasks: [
          {:cmd, "just ci-quiet"}
        ]
      ]
    ]
end
