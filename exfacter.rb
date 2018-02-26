Facter.add(:oracle_facter, :type => :aggregate) do
 username = Facter::Core::Execution.execute('ps -ef|egrep "ora_pmon_|asm_pmon_"|grep -v grep | awk \'{print $NF}\'|awk -F\'_\' \'{print $NF}\'', options = {:timeout => 5})
 username1 = nil
 if username
    chunk(:orasid) do
           begin
              Facter::Core::Execution.execute('ps -ef|egrep "ora_pmon_|asm_pmon_"|grep -v grep | awk \'{print $NF}\'|awk -F\'_\' \'{print $NF}\'', options = {:timeout => 5})
           rescue Facter::Core::Execution::ExecutionFailure
              'timeout!'
           end
    end

    chunk(:installedPath) do
           begin
              Facter::Core::Execution.execute('pmap $( ps -ef|egrep "ora_pmon_|asm_pmon_"|grep -v grep|awk \'{print $2}\')|grep /lib/libsk|awk -F"/lib/libsk" \'{print $1}\'|awk \'{print $NF}\'| sort | uniq', options = {:timeout => 5})
           rescue Facter::Core::Execution::ExecutionFailure
              'timeout!'
           end
    end

    chunk(:oracle_user) do
           begin
              Facter::Core::Execution.execute('ps -ef|egrep "ora_pmon_|asm_pmon_"|grep -v grep | awk \'{print $1}\'', options = {:timeout => 5})
           rescue Facter::Core::Execution::ExecutionFailure
              'timeout!'
           end
    end

    chunk(:version) do
           begin
              Facter::Core::Execution.execute('su - $(ps -ef|egrep "ora_pmon_|asm_pmon_"|grep -v grep | awk \'{print $1}\') -c  "sqlplus -v|grep -v ^$|awk \'{print $3}\'"', options = {:timeout => 5})
           rescue Facter::Core::Execution::ExecutionFailure
              'timeout!'
           end
    end

    chunk(:helloworld) do
           begin
              Facter::Core::Execution.execute('/tmp/exfacter/echo.sh', options = {:timeout => 5})
           rescue Facter::Core::Execution::ExecutionFailure
              'timeout!'
           end
    end

    chunk(:orasid_user) do
          command = 'su - oracle  -c  "sqlplus -v|grep -v ^$|awk ' + "'{print $3}'" + '"'
          Facter::Core::Execution.execute(command,  options = {:timeout => 5})
    end

   #aggregate block goes here
   aggregate do |chunks|
     result = Hash.new
     list = Array.new
     result1 = Hash.new
     result2 = Hash.new
     list = [result1,result2]
     result1['parameter1'] = chunks
     result2['parameter2'] = chunks
     result['orasid']= chunks[:orasid]
     result['installedPath']= chunks[:installedPath]
     result['oracle_user']= chunks[:oracle_user]
     result['version']= chunks[:version]
     result['list']= list

     # Result: "Chunk one returns this. Chunk two returns this."
     result
   end
 else 
     'nill'
 end 
end
