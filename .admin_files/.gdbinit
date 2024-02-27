break test()

define start-test
	break test()
	run
	step
end

define run-test
	break test()
	run
	step
	continue
end
