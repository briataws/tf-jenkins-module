# load data from Terraform output
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)

alb_dns = params['alb_dns_name']['value']
route_53_dns = params['route_53_dns_name']['value']

# dns_list = ["#{alb_dns}", "#{route_53_dns}"] # Commenting out till we have a real domain in sandbox
dns_list = ["#{alb_dns}"]

dns_list.each do |host|
  describe http("http://#{host}") do
    its('status') { should cmp 200 }
    its('body') { should include 'Brian Carpio'}
    its('body') { should include 'Intersections'}
  end
end

