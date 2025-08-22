{
  description = "A very basic flake";

  inputs = {
  };

  outputs = _: {
    files.default = ./.;
  };
}
