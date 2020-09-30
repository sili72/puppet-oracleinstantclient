# oracle_version.rb

Facter.add("oracle_version") do
        setcode do
                # %x{/bin/rpm -q oracle-instantclient | /bin/sed s/oracle-instantclient-// | /bin/sed s/-[0-9]// | /bin/sed s/\.noarch// | /bin/sort -u | /usr/bin/uniq | /usr/bin/tail -n 1}.chomp
                if File.exists?('/bin/rpm') && File.exists?('/bin/cut') && File.exists?('/bin/sort') && File.exists?('/usr/bin/uniq')
                        %x{/bin/rpm -q oracle-instantclient | /bin/cut -d'-' -f 3 | /bin/sort -u | /usr/bin/uniq}.chomp
                elseif File.exists?('/usr/bin/rpm') && File.exists?('/usr/bin/cut') && File.exists?('/usr/bin/sort') && File.exists?('/usr/bin/uniq')
                        %x{/usr/bin/rpm -q oracle-instantclient | /usr/bin/cut -d'-' -f 3 | /usr/bin/sort -u | /usr/bin/uniq}.chomp
                end
        end
end
