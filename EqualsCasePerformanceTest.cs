 [TestClass]
    public class EqualsTest
    {
        [TestMethod]
        public void Compare()
        {
            Stopwatch sw = new Stopwatch();
            sw.Start();

            for (int i = 0; i < 50000000; i++)
            {
                string left = (i + 1).ToString();
                string right = (i + 1).ToString();
                // A
                // var resultA = left.Equals(right, StringComparison.InvariantCultureIgnoreCase);

                // B
                //var resultB = left == right;

                // C
                var resultA = left.ToLower() == right.ToLower();
            }

            sw.Stop();
            Console.WriteLine("Duration: " + sw.Elapsed);
        }

    }