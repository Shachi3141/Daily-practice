program nearest_neighbors
    implicit none
    integer :: x, y, i, j
  
    ! Input coordinates
    x=2
    y=2
  
    print *, "N2  Nearest neighbors of (", x, ",", y, ") are:"
  
    ! Loop over all possible combinations of x-1, x, x+1 and y-1, y, y+1
    
    do i = x - 1, x + 1
       do j = y - 1, y + 1
             print *, "(", i, ",", j, ")"
       end do
    end do
  
    print *, "N1  Nearest neighbors of (", x, ",", y, ") are:"
    do j = y - 1, y + 1
        print *, "(", x, ",", j, ")"
    end do
    do i = x - 1, x + 1
        print *, "(", i, ",", y, ")"
    end do

    print *, "N3  Nearest neighbors of (", x, ",", y, ") are:"
    do j = y - 2, y + 2, 2
        if (j /= y) then
            print *, "(", x, ",", j, ")"
        end if
    end do
    do i = x - 2, x + 2, 2
        if (i /= x) then
            print *, "(", i, ",", y, ")"
        end if
    end do
    do i = x - 1, x + 1
        do j = y - 1, y + 1
            if (i /= x .or. j /= y) then
              print *, "(", i, ",", j, ")"
            end if
        end do
     end do
  end program nearest_neighbors
  