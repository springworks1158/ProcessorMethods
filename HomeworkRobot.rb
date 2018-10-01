END {	
	#============================================First in Last Out
	proc1 = CProc.new(1, 4, 0)
	proc2 = CProc.new(2, 5, 3)
	proc3 = CProc.new(3, 2, 6)
	
	puts "Part 1: First in Last Out Method"	
	solve([proc1, proc2, proc3], 1)
	
	#============================================Biggest First
	proc1 = CProc.new(1, 5, 0)
	proc2 = CProc.new(2, 10, 2)
	proc3 = CProc.new(3, 2, 1)
	proc4 = CProc.new(4, 6, 7)
	proc5 = CProc.new(5, 1, 10)
		
	puts "Part 2a: Biggest First Method"
	solve([proc1, proc2, proc3, proc4, proc5], 2)
	
	#============================================Shortest First
	proc1 = CProc.new(1, 5, 0)
	proc2 = CProc.new(2, 10, 2)
	proc3 = CProc.new(3, 2, 1)
	proc4 = CProc.new(4, 6, 7)
	proc5 = CProc.new(5, 1, 10)
	
	puts "Part 2b: Shortest First Method"
	solve([proc1, proc2, proc3, proc4, proc5], 3)
	
	#============================================Round Robin n = 1
	p1 = CProc.new(1, 6, 0)
	p2 = CProc.new(2, 10, 2)
	p3 = CProc.new(3, 7, 3)
	p4 = CProc.new(4, 6, 7)
	p5 = CProc.new(5, 3, 10)
	
	puts "Part 3a: Round Robin n = 1"
	solve([p1, p2, p3, p4, p5], 4, 1)
	
	#===========================================Round Robin n = 3
	p1 = CProc.new(1, 6, 0)
	p2 = CProc.new(2, 10, 2)
	p3 = CProc.new(3, 7, 3)
	p4 = CProc.new(4, 6, 7)
	p5 = CProc.new(5, 3, 10)
	
	puts "Part 3b: Round Robin n = 2"
	solve([p1, p2, p3, p4, p5], 4, 2)

	#==========================================Round Robin n = 5
	p1 = CProc.new(1, 6, 0)
	p2 = CProc.new(2, 10, 2)
	p3 = CProc.new(3, 7, 3)
	p4 = CProc.new(4, 6, 7)
	p5 = CProc.new(5, 3, 10)
	
	puts "Part 3c: Round Robin n = 5"
	solve([p1, p2, p3, p4, p5], 4, 5)
}


class CProc
	attr_accessor :id, :activationTime, :timeToProcess, :timeLeftToProcess, :visualProcessing, :throughput	
	def initialize(id, length, activeTime)
		@id = id
		@activationTime = activeTime
		@timeToProcess = length
		@timeLeftToProcess = length
		@visualProcessing = "#{id} |"
		@completionTime = 0
		@throughput = 0
	end

	def processIfId(id, time)
		if @id == id
			#change = @timeLeftToProcess	
			@timeLeftToProcess -= 1	
			@visualProcessing += "=" unless @activationTime == time
			@visualProcessing += "!" if @activationTime == time
			#puts "id: #{@id} timeLeft: #{change} => #{@timeLeftToProcess}" 
			@completionTime = time + 1 if @timeLeftToProcess == 0
			@throughput = @completionTime - @activationTime
		else
			if @activationTime == time
				@visualProcessing += "x"
			else
				@visualProcessing += " "
			end
		end
	end

	def getStats()
		return "| #{@id} |      #{@activationTime}       |       #{@completionTime}        |     #{@throughput}     |"
	end
end


def procsFinished(processes)
	processingCompleted = false
	processes.each do |x|
		if x.timeLeftToProcess != 0
			processingCompleted = false
			break
		else processingCompleted = true end
	end
	processingCompleted ? true : false 
end

def biggestFirst(processes, currentTime)
	longestTimeToProcess = 0
	longestIdToProcess = 0
	processes.each do |x|
		# choose process if active, longest proc time, and not done processing
		if x.activationTime <= currentTime and x.timeToProcess > longestTimeToProcess and !(x.timeLeftToProcess <= 0) 
			longestIdToProcess = x.id
			longestTimeToProcess = x.timeToProcess	
		end
	end
	return longestIdToProcess
end

def shortestFirst(processes, currentTime)
	shortestTimeToProcess = 1000
	shortestIdToProcess = 0
	processes.each do |x|
		if x.activationTime <= currentTime and x.timeToProcess < shortestTimeToProcess and !(x.timeLeftToProcess <= 0)
			shortestIdToProcess = x.id
			shortestTimeToProcess = x.timeToProcess
		end
	end
	return shortestIdToProcess
end

def firstInLastOut(processes, currentTime)
	#choose the most recently arrived process
	mostRecentId = 0
	mostRecentIdRange = 1000
	processes.each do |x|
		if currentTime - x.activationTime >= 0 and currentTime - x.activationTime < mostRecentIdRange
			if !(x.timeLeftToProcess <= 0)
				mostRecentId = x.id
				mostRecentRange = currentTime - x.activationTime
		
			end
		end
	end
	return mostRecentId
end

def roundRobin(processes, currentTime, n)
	processes.each do |x|
		n.times {
			if x.activationTime <= currentTime and !(x.timeLeftToProcess <= 0)
				#must cycle through all because of early design choices
				processes.each { |y| y.processIfId(x.id, currentTime) }
				currentTime += 1
			end
		}
	end
	return currentTime
end

def printGraph(processes, finalTime)
	puts ""
	puts "#"

	for x in processes
		puts "#{x.visualProcessing}"
	end

	print "..."
	for i in (0...finalTime)
		tens = i / 10
		print "#{tens}"
	end
	
	puts ""
	print "..."
	for i in (0...finalTime)
		ones = i % 10
		print "#{ones}"
	end
	puts ""
	puts ""	
end

def solve(processes, operation, n=1)
	time = 0
	while true do 	
		if operation == 4
			time = roundRobin(processes, time, n) 
			break if procsFinished(processes)
		else
			#print "time: #{time} | "		
			case operation
			when 0
				#selectedId = firstInFirstOut(processes, time)
			when 1
				selectedId = firstInLastOut(processes, time)
			when 2
				selectedId = biggestFirst(processes, time)
			when 3
				selectedId = shortestFirst(processes, time)
			else
				puts "invalid solving method"
			end
		
			#process the selected id
			processes.each { |x| x.processIfId(selectedId, time) }	
		
			time += 1
			#if time > 30 then break end
			break if procsFinished(processes)
		end
	end

	printGraph(processes, time)
	
	puts "| # | arrival time | completion time | throughput |"
	processes.each() do |x|
		puts "#{x.getStats()}"
	end
	puts ""
	
	averageThroughput = 0.0	
	numProcs = 0.0
	processes.each() do |x|
		averageThroughput += x.throughput 
		numProcs += 1.0
	end
	averageThroughput /= numProcs
	puts "average throughput: #{averageThroughput}"
	puts ""
	puts "====================================================================================="
	puts ""
end

BEGIN {
	puts ""
	puts "==========!!!ANSWERS!!!=============================================================="
	puts ""
	puts "Key:"
	puts "    '=' => process executed at this time"
	puts "    'x' => process arrived at this time"
	puts "    '!' => process executed and arrived at this time"
	puts ""
	puts "*time is read vertically (top to bottom)"
	puts "====================================================================================="
	puts ""
}


