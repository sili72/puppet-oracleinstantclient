# oracle_version.rb

Facter.add("oracle_version") do
        setcode do
                # %x{/bin/rpm -q oracle-instantclient | /bin/sed s/oracle-instantclient-// | /bin/sed s/-[0-9]// | /bin/sed s/\.noarch// | /bin/sort -u | /usr/bin/uniq | /usr/bin/tail -n 1}.chomp
                %x{/bin/rpm -q oracle-instantclient | /bin/cut -d'-' -f 3 | /bin/sort -u | /usr/bin/uniq}.chomp
        end
end
