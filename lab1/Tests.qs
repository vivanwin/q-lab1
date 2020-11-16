// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks.
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.BasicGates {
    
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;
    open Quantum.Kata.Utils;
    open Microsoft.Quantum.Random;
    
    //////////////////////////////////////////////////////////////////
    // Part I. Single-Qubit Gates
    //////////////////////////////////////////////////////////////////

    // The tests in part I are written to test controlled versions of operations instead of plain ones.
    // This is done to verify that the tasks don't add a global phase to the implementations.
    // Global phase is not relevant physically, but it can be very confusing for a beginner to consider R1 vs Rz,
    // so the tests use controlled version of the operations which converts the global phase into a relative phase
    // and makes it possible to detect.

    // ------------------------------------------------------
    // Helper wrapper to represent operation on one qubit 
    // as an operation on an array of one qubits
    operation ArrayWrapper (op : (Qubit => Unit is Adj+Ctl), qs : Qubit[]) : Unit is Adj+Ctl {
        op(qs[0]);
    }

    // ------------------------------------------------------
    // Helper wrapper to represent controlled variant of operation on one qubit 
    // as an operation on an array of two qubits
    operation ArrayWrapperControlled (op : (Qubit => Unit is Adj+Ctl), qs : Qubit[]) : Unit is Adj+Ctl {
        Controlled op([qs[0]], qs[1]);
    }


    // ------------------------------------------------------
    // Helper operation to show the difference between the reference solution and the learner's one
    operation DumpDiff (N : Int, 
                        statePrep : (Qubit[] => Unit is Adj+Ctl),
                        testImpl : (Qubit[] => Unit is Adj+Ctl),
                        refImpl : (Qubit[] => Unit is Adj+Ctl)
                       ) : Unit {
        using (qs = Qubit[N]) {
            // Prepare the input state and show it
            statePrep(qs);
            Message("The starting state:");
            DumpMachine();

            // Apply the reference solution and show result
            refImpl(qs);
            Message("The desired state:");
            DumpMachine();
            ResetAll(qs);

            // Prepare the input state again for test implementation
            statePrep(qs);
            // Apply learner's solution and show result
            testImpl(qs);
            Message("The actual state:");
            DumpMachine();
            ResetAll(qs);
        }
    }


    // Used for single-qubit operations that are unlikely to introduce the extra global phase
    operation DumpDiffOnOneQubit (testImpl : (Qubit => Unit is Adj+Ctl),
                                  refImpl : (Qubit => Unit is Adj+Ctl)) : Unit {
        DumpDiff(1, ArrayWrapper(Ry(2.0 * ArcCos(0.6), _), _), 
                ArrayWrapper(testImpl, _), 
                ArrayWrapper(refImpl, _));
    }


    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T101_StateFlip () : Unit {
        DumpDiffOnOneQubit(StateFlip, StateFlip_Reference);
        AssertOperationsEqualReferenced(2, ArrayWrapperControlled(StateFlip, _), 
                                           ArrayWrapperControlled(StateFlip_Reference, _));
    }
    
    
    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T102_BasisChange () : Unit {
        DumpDiffOnOneQubit(BasisChange, BasisChange_Reference);
        AssertOperationsEqualReferenced(2, ArrayWrapperControlled(BasisChange, _), 
                                           ArrayWrapperControlled(BasisChange_Reference, _));
    }
    
    
    // ------------------------------------------------------
    @Test("QuantumSimulator")
    operation T103_SignFlip () : Unit {
        DumpDiffOnOneQubit(SignFlip, SignFlip_Reference);
        AssertOperationsEqualReferenced(2, ArrayWrapperControlled(SignFlip, _), 
                                           ArrayWrapperControlled(SignFlip_Reference, _));
    }
    
    @Test("QuantumSimulator")
    operation T104_MultipleGates () : Unit {
        DumpDiffOnOneQubit(MultipleGates, MultipleGates_Reference);
        AssertOperationsEqualReferenced(2, ArrayWrapperControlled(MultipleGates, _), 
                                           ArrayWrapperControlled(MultipleGates_Reference, _));
    }
    
    

    //////////////////////////////////////////////////////////////////
    // Part III. Random numbers
    //////////////////////////////////////////////////////////////////

     operation CheckFlatDistribution (f : (Int => Int), numBits : Int, lowRange : Double, highRange : Double, nRuns : Int, minimumCopiesGenerated : Int) : Unit {
        let max = PowI(2, numBits);
        mutable counts = ConstantArray(max, 0);
        mutable average = 0.0;

        ResetOracleCallsCount();
        for (i in 1..nRuns) {
            let val = f(numBits);
            if (val < 0 or val >= max) {
                fail $"Unexpected number generated. Expected values from 0 to {max - 1}, generated {val}";
            }
            set average += IntAsDouble(val);
            set counts w/= val <- counts[val] + 1;
        }
        CheckRandomCalls();

        set average = average / IntAsDouble(nRuns);
        if (average < lowRange or average > highRange) {
            fail $"Unexpected average of generated numbers. Expected between {lowRange} and {highRange}, got {average}";
        }

        let median = FindMedian (counts, max, nRuns);
        if (median < Floor(lowRange) or median > Ceiling(highRange)) {
            fail $"Unexpected median of generated numbers. Expected between {Floor(lowRange)} and {Ceiling(highRange)}, got {median}.";

        }

        for (i in 0..max - 1) {
            if (counts[i] < minimumCopiesGenerated) {
               // fail $"Unexpectedly low number of {i}'s generated. Only {counts[i]} out of {nRuns} were {i}";
            }
        }
    }

    operation FindMedian (counts : Int [], arrSize : Int, sampleSize : Int) : Int {
        mutable totalCount = 0;
        for (i in 0..arrSize - 1) {
            set totalCount = totalCount + counts[i];
            if (totalCount >= sampleSize / 2) {
                return i;
            }
        }
        return -1;
    }

    operation RandomBit_Wrapper (throwaway: Int) : Int {
        return RandomBit();
    }

    operation RandomTwoBits_Wrapper (throwaway: Int) : Int {
        return RandomTwoBits();
    }
    operation RandomTwo_Wrapper (throwaway: Int) : Int {
        return RandomTwo();
    }

    operation CheckRandomCalls () : Unit {
        Fact(GetOracleCallsCount(DrawRandomInt) == 0, "You are not allowed to call DrawRandomInt() in this task");
        Fact(GetOracleCallsCount(DrawRandomDouble) == 0, "You are not allowed to call DrawRandomDouble() in this task");
        ResetOracleCallsCount();
    }

    // Exercise 1.
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T1_RandomBit () : Unit {
        Message("Testing...");
        CheckFlatDistribution(RandomBit_Wrapper, 1, 0.4, 0.6, 1000, 450);
    }

    // Exercise 2.
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T2_RandomTwo () : Unit {
        Message("Testing...");
        CheckFlatDistribution(RandomTwo_Wrapper, 2, 0.5, 1.3, 1000, 200);
    }

    // Exercise 3.
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T3_RandomTwoBits () : Unit {
        Message("Testing...");
        CheckFlatDistribution(RandomTwoBits_Wrapper, 2, 1.4, 1.6, 1000, 200);
    }
    

    // Exercise 4.
    @Test("Microsoft.Quantum.Katas.CounterSimulator")
    operation T4_RandomNBits () : Unit {
        Message("Testing N = 1...");
        CheckFlatDistribution(RandomNBits, 1, 0.4, 0.6, 1000, 450);
        Message("Testing N = 2...");
        CheckFlatDistribution(RandomNBits, 2, 1.4, 1.6, 1000, 200);
        Message("Testing N = 3...");
        CheckFlatDistribution(RandomNBits, 3, 3.3, 3.7, 1000, 90);
        Message("Testing N = 10...");
        CheckFlatDistribution(RandomNBits, 10, 461.0, 563.0, 1000, 0);
    }

}
