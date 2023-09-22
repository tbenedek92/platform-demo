terraform {
  cloud {
    organization = "tbenedek-platform-demo"

    workspaces {
      name = "eks"
    }
  }
}
