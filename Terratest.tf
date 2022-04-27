
vi testauto.go


package test

import (
  "fmt"
  "testing"

  "github.com/gruntwork-io/terratest/modules/aws"
  "github.com/gruntwork-io/terratest/modules/random"
  "github.com/gruntwork-io/terratest/modules/terraform"
)

func Testflugel(t *testing.T) {

  awsRegion := "eu-west-2"

  terraformOpts := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

    TerraformDir: "../home/crobayo/",

    Vars: map[string]interface{}{
      "bucket_name": "Flugel",
	  "tag_owner": "InfraTeam",
	  "ec2_name": "Flugel",
    },

    EnvVars: map[string]string{
      "AWS_DEFAULT_REGION": awsRegion,
    },
  })

  defer terraform.Destroy(t, terraformOpts)

  terraform.InitAndApply(t, terraformOpts)

  bucketname := terraform.Output(t, terraformOpts, "bucket_name")
  Ownertag := terraform.Output(t, terraformOpts, "tag_owner")
  Ec2name := terraform.Output(t, terraformOpts, "ec2_name")

  actualowner := aws.gets3buckettagging(t, awsRegion, Ownertag)
  actualname := aws.gets3buckettagging(t, awsRegion, bucketname)
  actualec2name := aws.ec2.describeinstancesfilterstag(t, awsRegion, bucketname)
  
  assert.Equal(t, "Enabled", actualowner)
  assert.Equal(t, "Enabled", actualname)
  assert.Equal(t, "Enabled", actualec2name)
}