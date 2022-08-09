package main

import (
	"errors"
	"sort"
)

const (
	LIMIT_CARDS                          = 7
	VALUE_OF_AS_NUMBER                   = 14
	MINIMUM_CARDS_FOR_CONSECUTIVE_POCKER = 5
)

type cardsListType []int

func isStraight(cardList cardsListType) (bool, error) {
	if len(cardList) > LIMIT_CARDS {
		return false, errors.New("Supera el máximo permitido de tarjetas")
	}

	cardList = findASNumbersAndConvert(cardList)

	//Order numbers
	sort.Ints(cardList)

	isConsecutiveNumber := verifyIfIsConsecutive(cardList)
	return isConsecutiveNumber, nil

}

func findASNumbersAndConvert(cardList cardsListType) (cards cardsListType) {
	for _, value := range cardList {
		convertedNumber := convertNumberToAS(value)
		cards = append(cards, convertedNumber)
	}
	return cards
}

func convertNumberToAS(number int) int {
	if number == VALUE_OF_AS_NUMBER {
		return 1
	}
	return number
}

func verifyIfIsConsecutive(cardList cardsListType) bool {
	lastIndex := len(cardList) - 1
	cantConsecutiveNumbers := 0

	for i, _ := range cardList {
		//If is first item, evaluate next number
		if i == 0 {
			continue
		}

		previusNumber := cardList[i-1]
		currentNumber := cardList[i]
		isConsecutiveNumber := (currentNumber - previusNumber) == 1
		if isConsecutiveNumber {
			cantConsecutiveNumbers++
		}
		//Evalaute last item, in cases when is consecutive last number the loop ignore case
		isLastIndex := (i == lastIndex)
		if isLastIndex && isConsecutiveNumber {
			cantConsecutiveNumbers++
		}
	}
	//Conditional for evaluate if is consecutive
	return cantConsecutiveNumbers >= MINIMUM_CARDS_FOR_CONSECUTIVE_POCKER
}
