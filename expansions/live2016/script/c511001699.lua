--Cardian - Susuki ni Tsuki
function c511001699.initial_effect(c)
	c:EnableUnsummonable()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511001699,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c511001699.spcost)
	e1:SetTarget(c511001699.sptg)
	e1:SetOperation(c511001699.spop)
	c:RegisterEffect(e1)
	c511001699.spe=e1
end
function c511001699.spcon(c,e)
	if c==nil or not e then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,c511001699.filter,1,nil) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001699.filter(c)
	local re=c:GetReasonEffect()
	local spchk=bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)
	return c:GetLevel()==8 and c:IsSetCard(0xe3)
		and (spchk==0 or (spchk~=0 and (not re or not re:GetHandler():IsSetCard(0xe3) or not re:GetHandler():IsType(TYPE_MONSTER))))
end
function c511001699.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c511001699.filter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c511001699.filter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c511001699.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c511001699.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		Duel.Draw(tp,1,REASON_EFFECT)
		if tc then
			Duel.ConfirmCards(1-tp,tc)
			if not tc:IsSetCard(0xe3) or not tc.spcon(tc,tc.spe) then
				Duel.BreakEffect()
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
			Duel.ShuffleHand(tp)
		end
	end
end
