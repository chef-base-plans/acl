title 'Tests to confirm acl works as expected'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input('plan_name', value: 'acl')

control 'core-plans-acl-works' do
  impact 1.0
  title 'Ensure acl works as expected'
  desc '
  '
  plan_installation_directory = command("hab pkg path #{plan_origin}/#{plan_name}")
  describe plan_installation_directory do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end
  
  plan_pkg_ident = ((plan_installation_directory.stdout.strip).match /(?<=pkgs\/)(.*)/)[1]
  plan_pkg_version = (plan_pkg_ident.match /^#{plan_origin}\/#{plan_name}\/(?<version>.*)\//)[:version]
  describe command("DEBUG=true; hab pkg exec #{plan_pkg_ident} getfacl --version") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /getfacl #{plan_pkg_version}/}
    its('stderr') { should be_empty }
  end
end
