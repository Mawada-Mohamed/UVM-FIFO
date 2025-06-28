vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all -cover
add wave /top/f_if/*
coverage save top.ucdb -onexit
coverage exclude -src FIFO.sv -line 43 -code c
coverage exclude -src FIFO.sv -line 26 -code c
run -all
# quit -sim
#vcover report top.ucdb -details -annotate -all -output cov_repo

