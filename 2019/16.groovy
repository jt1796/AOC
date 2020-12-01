import java.time.*

int[] nums = (new File('16.txt').text * 100).split('').collect { it.toInteger() }.toArray();
//nums = "12345678".split('').collect { it.toInteger() }.toArray();
//println(nums);

// nums.length ^ 2 / 2
def FFT(nums) {
    println(LocalDateTime.now())
    int[] pattern = [0, 1, 0, -1].toArray();
    int[] newnums = new int[nums.length];
    for (int i = 0; i < nums.length; i++) {
        for (int j = i; j < nums.length; j++) {
            int b = (j + 1  ) % ((i + 1)*4);
            int p = pattern[b / (i + 1)];
            newnums[i] += nums[j] * pattern[p];
        }
    }
    for (int i = 0; i < newnums.length; i++) {
        newnums[i] = Math.abs(newnums[i] % 10);
    }
    return newnums;
}

for (i = 0; i < 100; i++) {
    nums = FFT(nums);
}
println(nums);
