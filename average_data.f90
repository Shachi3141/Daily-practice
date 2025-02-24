program average_data
    implicit none
    integer, parameter :: n = 20  ! Number of input files
    integer, parameter :: max_rows = 10000  ! Adjust based on expected data size
    integer :: i, j, count
    real(8), dimension(max_rows) :: time, sum_col1, avg_col1, sum_col2, avg_col2, sum_col3, avg_col3, &
    sum_col4, avg_col4, sum_col5, avg_col5, sum_col6, avg_col6
    real(8) :: temp_value1, temp_value2, temp_value3, temp_value4, temp_value5, temp_value6  
    character(len=50) :: filename
    logical :: first_file

    ! Initialize arrays
    sum_col1 = 0.0
    avg_col1 = 0.0
    sum_col2 = 0.0
    avg_col2 = 0.0
    sum_col3 = 0.0
    avg_col3 = 0.0
    sum_col4 = 0.0
    avg_col4 = 0.0
    sum_col5 = 0.0
    avg_col5 = 0.0
    sum_col6 = 0.0
    avg_col6 = 0.0
    count = 0
    first_file = .true.

    ! file='RSAD_diffu.txt'
    ! file='RSAD_density.txt'
    ! file='gij.txt'
    ! file='g.txt'

    ! Read data from all files and accumulate sum
    do i = 1, n
        write(filename, '(A,I0,A)') "gij", i, ".txt"  ! Generate filename like c1.txt, c2.txt
        open(10, file=trim(filename), status='old', action='read')
        
        j = 0
        do
            j = j + 1
            read(10, *, end=100) time(j), temp_value1, temp_value2, temp_value3, temp_value4, temp_value5, temp_value6 
            sum_col1(j) = sum_col1(j) + temp_value1  ! Accumulate sum
            sum_col2(j) = sum_col2(j) + temp_value2  ! Accumulate sum
            sum_col3(j) = sum_col3(j) + temp_value3  ! Accumulate sum
            sum_col4(j) = sum_col4(j) + temp_value4  ! Accumulate sum
            sum_col5(j) = sum_col5(j) + temp_value5  ! Accumulate sum
            sum_col6(j) = sum_col6(j) + temp_value6  ! Accumulate sum
            if (first_file) count = count + 1  ! Count rows only for the first file
        end do
100     close(10)
        first_file = .false.
    end do


    ! Compute the average
    do j = 1, count
        avg_col1(j) = sum_col1(j) / real(n, 8)
        avg_col2(j) = sum_col2(j) / real(n, 8)
        avg_col3(j) = sum_col3(j) / real(n, 8)
        avg_col4(j) = sum_col4(j) / real(n, 8)
        avg_col5(j) = sum_col5(j) / real(n, 8)
        avg_col6(j) = sum_col6(j) / real(n, 8)
    end do

    ! Write averaged data to new file
    open(20, file="avg_gij.txt", status="replace", action="write")
    do j = 1, count
        write(20, '( 7F18.8)') time(j), avg_col1(j), avg_col2(j), avg_col3(j), avg_col4(j), avg_col5(j), avg_col6(j)
    end do
    close(20)

    print *, "Averaged data written to avg_data.txt"

end program average_data
