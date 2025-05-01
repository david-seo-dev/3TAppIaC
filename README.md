**Discover the power of 3-Tier Architecture!**  
A 3-Tier Architecture app separates the presentation, application, and database layers, enhancing scalability, manageability, and security. This project showcases a robust AWS implementation of the architecture.

---

## 🚀 **In this Project, I have used the following AWS services:**

- **VPC**
- **S3**
- **IAM**
- **EC2**
- **RDS**
- **Route 53**

The code is from a sample tutorial - I wanted to demonstrate the IaC and 3T as I talk through the example.

What have I done for Clickops
Creating VPC and subnets (Would be nice to using IAC - ran out of time)
Uploading application code to S3 for EC2 to mount (Would like to change that to a proper solution in future)

Tips - Troubleshooting how do I SSH?
Can use SSM agent using the IAM roles to attach to each EC2 - role name is caled is "Demo-EC2-Role" which is AmazonEC2RoleforSSM

What was done by TF
* SGs
* S3 and EC2s for the app tier
* RDS (Did not create multi az zone because $ want this to be in free tier)
* ALB and EC2


Future improvements!
General improvements
  CI/CD using github - instead of uploading using S3
  Environment dev,qa, SLDC/environment gates - this would require some tfvars and creating the "Same" resources

Terraform improvements
  Using Datablocks instead of hardcoding or templates with a main.tf and "passing" variables inbetween (Ran out of time to do this and hardcoded a few places - a personal no no but time limits haha)

Database improvments
  For RDS we could also add in some caching for performance if we ever needed that https://aws.amazon.com/caching/database-caching/
  For RDS proxy could also be a thing to consider if we're seeing lots of incoming request eating up connections (for the purpose of this exercise we don't need it)
  Database backups - Been disabled for this execrise ONLY because.. it cost money. HOWEVER! Normally we would DEFINITELY want this based on secops's recommendations.
  If there was a budget we would want to create RDS - from free tier to multi az zone availability.
  Read replica! Would be nice if we are seeing performance read-write issues as our service gets consumed more.

EC2 improvements
  Love to use ASG properly but I don't have the time yet to add that in.

Really nice to have
  "Blue/green" deployment with staging -> production for RDS - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/blue-green-deployments.html
