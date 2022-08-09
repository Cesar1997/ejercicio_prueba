package main

import (
	"testing"
)

func TestIsStraight(t *testing.T) {
	testCases := []struct {
		name       string
		cardList   cardsListType
		isStraight bool
		wantErr    bool
	}{
		{
			name:       "CASE 1 : [2, 3, 4 ,5, 6]",
			cardList:   cardsListType{2, 3, 4, 5, 6},
			isStraight: true,
			wantErr:    false,
		},
		{
			name:       "CASE 2 : [14, 5, 4 ,2, 3]",
			cardList:   cardsListType{14, 5, 4, 2, 3},
			isStraight: true,
			wantErr:    false,
		},
		{
			name:       "CASE 3 : [14,2,3,4,5]",
			cardList:   cardsListType{14, 2, 3, 4, 5},
			isStraight: true,
			wantErr:    false,
		},
		{
			name:       "CASE 4 : [2,7,8,5,10,9,11]",
			cardList:   cardsListType{2, 7, 8, 5, 10, 9, 11},
			isStraight: true,
			wantErr:    false,
		},
		{
			name:       "CASE 5 : [7, 7, 12 ,11, 3, 4, 14]",
			cardList:   cardsListType{7, 7, 12, 11, 3, 4, 14},
			isStraight: false,
			wantErr:    false,
		},
		{
			name:       "CASE 5 : [7, 3, 2]",
			cardList:   cardsListType{7, 3, 2},
			isStraight: false,
			wantErr:    false,
		},
		{
			name:       "CASE 6 : [7-8-12-13-14]",
			cardList:   cardsListType{7, 8, 12, 13, 14},
			isStraight: false,
			wantErr:    false,
		},
		{
			name:       "CASE 7: expected error [1,2,3,4,5,6,7,8]",
			cardList:   cardsListType{1, 2, 3, 4, 5, 6, 7, 8},
			isStraight: false,
			wantErr:    true,
		},
	}
	for _, test := range testCases {
		t.Run(test.name, func(t *testing.T) {
			//call the method for evaluate
			got, err := isStraight(test.cardList)
			if (err != nil) != test.wantErr {
				t.Errorf("isStraight() error = %v, wantErr %v", err, test.wantErr)
				return
			}
			if got != test.isStraight {
				t.Errorf("isStraight() = %v, want %v", got, test.isStraight)
			}
		})
	}
}
