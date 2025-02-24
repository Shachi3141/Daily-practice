program average_data
    implicit none
    integer, parameter :: n = 20  ! Number of input files
    integer, parameter :: max_rows = 10000  ! Adjust based on expected data size
    integer :: i, j, count
    real(8), dimension(max_rows) :: time, sum_col, avg_col
    real(8) :: temp_value  ! Temporary variable for reading data
    character(len=50) :: filename
    logical :: first_file

    ! Initialize arrays
    sum_col = 0.0
    avg_col = 0.0
    count = 0
    first_file = .true.

    ! Read data from all files and accumulate sum
    do i = 1, n
        write(filename, '(A,I0,A)') "RSAD_density", i, ".txt"  ! Generate filename like c1.txt, c2.txt
        open(10, file=trim(filename), status='old', action='read')
        
        j = 0
        do
            j = j + 1
            read(10, *, end=100) time(j), temp_value  ! Read temp_value
            sum_col(j) = sum_col(j) + temp_value  ! Accumulate sum
            if (first_file) count = count + 1  ! Count rows only for the first file
        end do
100     close(10)
        first_file = .false.
    end do

    ! Compute the average
    do j = 1, count
        avg_col(j) = sum_col(j) / real(n, 8)
    end do

    ! Write averaged data to new file
    open(20, file="avg_density.txt", status="replace", action="write")
    do j = 1, count
        write(20, '(F12.6, 1X, F24.16)') time(j), avg_col(j)
    end do
    close(20)

    print *, "Averaged data written to avg_data.txt"

end program average_data
