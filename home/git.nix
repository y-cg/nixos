{
  # Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "y-cg";
        email = "159802291+y-cg@users.noreply.github.com";
      };
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
      };
    };
  };
}
